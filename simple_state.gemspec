# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_state}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Williams"]
  s.date = %q{2010-10-13}
  s.description = %q{A *very simple* state machine implementation.}
  s.email = %q{anthony@ninecraft.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "lib/simple_state.rb",
     "lib/simple_state/builder.rb",
     "lib/simple_state/mixins.rb",
     "spec/builder_spec.rb",
     "spec/event_methods_spec.rb",
     "spec/mixins_spec.rb",
     "spec/predicate_methods_spec.rb",
     "spec/simple_state_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/antw/simple_state}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A *very simple* state machine implementation.}
  s.test_files = [
    "spec/builder_spec.rb",
     "spec/event_methods_spec.rb",
     "spec/mixins_spec.rb",
     "spec/predicate_methods_spec.rb",
     "spec/simple_state_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

