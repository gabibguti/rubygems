require 'rubygems/test_case'
require 'rubygems/request_set'

class TestGemRequestSetGemDependencyAPI < Gem::TestCase

  def setup
    super

    @GDA = Gem::RequestSet::GemDependencyAPI

    @set = Gem::RequestSet.new

    @gda = @GDA.new @set, nil
  end

  def test_gem
    @gda.gem 'a'

    assert_equal [dep('a')], @set.dependencies
  end

  def test_gem_requirement
    @gda.gem 'a', '~> 1.0'

    assert_equal [dep('a', '~> 1.0')], @set.dependencies
  end

  def test_gem_requirements
    @gda.gem 'b', '~> 1.0', '>= 1.0.2'

    assert_equal [dep('b', '~> 1.0', '>= 1.0.2')], @set.dependencies
  end

  def test_gem_requirements_options
    @gda.gem 'c', :git => 'https://example/c.git'

    assert_equal [dep('c')], @set.dependencies
  end

  def test_group
    @gda.group do
      @gda.gem 'a'
    end

    assert_empty @set.dependencies
  end

  def test_load
    Tempfile.open 'Gemfile' do |io|
      io.puts 'gem "a"'
      io.flush

      gda = @GDA.new @set, io.path

      gda.load

      assert_equal [dep('a')], @set.dependencies
    end
  end

  def test_name_typo
    assert_same @GDA, Gem::RequestSet::DepedencyAPI
  end

  def test_platform_mswin
    @gda.platform :mswin do
      @gda.gem 'a'
    end

    assert_empty @set.dependencies
  end

  def test_platform_ruby
    @gda.platform :ruby do
      @gda.gem 'a'
    end

    assert_equal [dep('a')], @set.dependencies
  end

end
