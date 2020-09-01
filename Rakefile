require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  ENV['ELMURO_API_URL'] = 'http://elmuro-api-test'
  t.rspec_opts = '--color --format d'
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
  task.requires << 'rubocop-rspec'
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty --tags ~@wip'
end

task default: %i[spec rubocop]
