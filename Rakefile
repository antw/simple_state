require 'rubygems'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "simple_state"
    gem.platform    = Gem::Platform::RUBY
    gem.summary     = 'A *very simple* state machine implementation.'
    gem.description = gem.summary
    gem.email       = "anthony@ninecraft.com"
    gem.homepage    = "http://github.com/antw/simple_state"
    gem.authors     = ["Anthony Williams"]

    gem.extra_rdoc_files = %w(README.markdown LICENSE)

    gem.files = %w(LICENSE README.markdown Rakefile VERSION.yml) +
                Dir.glob("{lib,spec}/**/*")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install " \
       "technicalpickles-jeweler -s http://gems.github.com"
end

# rDoc =======================================================================

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'simple_state'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# rSpec & rcov ===============================================================

desc "Run all examples (or a specific spec with TASK=xxxx)"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts  = ["-c -f s"]
  t.spec_files = begin
    if ENV["TASK"]
      ENV["TASK"].split(',').map { |task| "spec/**/#{task}_spec.rb" }
    else
      FileList['spec/**/*_spec.rb']
    end
  end
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ['-c -f s']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

task :default => :spec
