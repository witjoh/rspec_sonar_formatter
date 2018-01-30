# RspecSonarFormatter

Rspec formatter to generates an xml file for SonarQube, using the generec-test-data format, 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_sonar_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_sonar_formatter

## Usage

Add the following in your spec/spec_helper.rb :

```
RSpec.configure do |c|
  c.formatter = 'documentation'
  c.add_formatter('RSpec::RspecSonarFormatter::Formatter', 'junit/reports_sonar.xml')
  ....
end
```

and add the following option to the sonar-scanner configuration, after you have run your rspec tests:

```
testExecutionReportPaths=junit/reports_sonar.xml
```

If you are uing a jenkins file, this can be done like:

```
stage('SonarQube Analysis') {
  steps {
   withSonarQubeEnv('Sonarqube puppet 6.7.1 LTS') {
    sh '''
      /opt/sonar-scanner/bin/sonar-scanner \
        --define "sonar.projectKey=puppet:${gitlabSourceRepoName}" \
        --define "sonar.projectName=${gitlabSourceRepoName}" \
        --define "sonar.projectVersion=${BUILD_ID}-${gitlabMergeRequestIid}" \
        --define "sonar.exclusions=spec/fixtures/**/*" \
        --define "sonar.testExecutionReportPaths=junit/reports_sonar.xml" \
       --define "sonar.sources=."
      '''
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/witjoh/rspec_sonar_formatter.
