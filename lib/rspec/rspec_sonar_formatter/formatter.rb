require "rspec_sonar_formatter/version"

module RSpec
  module RspecSonarFormatter
    class  Formatter
      RSpec::Core::Formatters.register self,
        :start,
        :stop,
        :example_failed,
        :example_passed,
        :example_pending,
        :example_group_started,

      def initialize(output)
        @output = output
        @current_file = ''
        @last_failure_index =0
      end

      def start(notification)
        @output.puts '<testExecutions version="1">'
      end

      def stop(notification)
        @output.puts '  </file>'
        @output.puts '</testExecutions>'
      end

      def example_group_started(notification)
        if notification.group.metadata[:file_path] != @current_file
          if @current_file != ''
            @output.puts "  </file>"
          end
          @output.puts "  <file path=\"#{notification.group.metadata[:file_path]}\">"
          @current_file = notification.group.metadata[:file_path]
        end
      end

      def example_failed(notification)
        @output.puts "    <testCase name=\"#{clean_string(notification.example.description)}\" duration=\"#{notification.example.execution_result.run_time}\">"
        @output.puts "      <failure message=\"#{notification.exception}\" stacktrace=\"#{notification.example.location}\"/>"
        @output.puts "    </testCase>"
      end

      def example_passed(notification)
        @output.puts "    <testCase name=\"#{clean_string(notification.example.description)}\" duration=\"#{notification.example.execution_result.run_time}\"/>"
      end

      def example_pending(notification)
        @output.puts "    <testCase name=\"#{clean_string(notification.example.description)}\" duration=\"#{notification.example.execution_result.run_time}\">"
        @output.puts "      <skipped message=\"#{clean_string(notification.example.execution_result.pending_message)}\"/>"
        @output.puts "    </testCase>"
      end

      def clean_string(s)
        s.gsub(/\e\[\d;*\d*m/,'')
        s.gsub(/"/,"'")
      end
    end
  end
end
