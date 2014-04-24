require 'sinatra'
require 'sass/plugin/rack'
require './index'

use Sass::Plugin::Rack

run GfmNotes
