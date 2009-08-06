$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'activerecord'
# HACK make sure we refer to AR:ARE before init so that AR:Assocations is there
# see: https://rails.lighthouseapp.com/projects/8994/tickets/2577
ActiveRecord::ActiveRecordError 
require 'init'
require 'models'
