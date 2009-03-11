# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_state}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Williams"]
  s.date = %q{2009-03-11}
  s.description = %q{A *very simple* state machine implementation.}
  s.email = %q{anthony@ninecraft.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["LICENSE", "README.markdown", "Rakefile", "VERSION.yml", "lib/simple_state", "lib/simple_state/builder.rb", "lib/simple_state/mixins.rb", "lib/simple_state.rb", "spec/builder_spec.rb", "spec/event_methods_spec.rb", "spec/mixins_spec.rb", "spec/predicate_methods_spec.rb", "spec/simple_state_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/anthonyw/simple_state}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A *very simple* state machine implementation.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
