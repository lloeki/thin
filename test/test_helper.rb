require 'rubygems'
require File.dirname(__FILE__) + '/../lib/thin'
require 'test/unit'
require 'mocha'
require 'benchmark'

Thin.logger = Logger.new(nil)

class TestRequest < Thin::Request
  def initialize(path, verb='GET', params={})
    @path = path
    @verb = verb.to_s.upcase
    @params = {
      'HTTP_HOST'      => 'localhost:3000',
      'REQUEST_URI'    => @path,
      'REQUEST_PATH'   => @path,
      'REQUEST_METHOD' => @verb,
      'SCRIPT_NAME'    => @path
    }.merge(params)
    
    @body = "#{@verb} #{path} HTTP/1.1"
  end
end

class Test::Unit::TestCase
  protected
    def assert_faster_then(max_time)
      time = Benchmark.measure { yield }.real * 1000
      assert time <= max_time, "Too slow : took #{time} ms, should take less then #{max_time} ms"
    end
end