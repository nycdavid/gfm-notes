require 'sinatra'
require 'sass/plugin/rack'
require './middlewares/note_backend'
require './index'

use Sass::Plugin::Rack
use Notes::NoteBackend

run GfmNotes
