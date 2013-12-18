==xtide for ruby

===Setup
Add `config/initializers/tide_path.rb`
```ruby
module Tide
  
  class TidePathNotFoundException < StandardError #:nodoc:
  end
  
  # Manages the path to the tide executable for the different operating 
  # environments.
  class TidePath
    # Read the path for the current ENV
    p Rails.root.to_s + '/config/tide_path.yml'
    unless File.exist?(Rails.root.to_s + '/config/tide_path.yml')
      raise TidePathNotFoundException.new("File RAILS_ROOT/config/tide_path.yml not found")
    else
      env = ENV['RAILS_ENV'] || RAILS_ENV
      TIDE_PATH = YAML.load_file(Rails.root.to_s + '/config/tide_path.yml')[env]
    end
    
    # Returns the path to the tide executable.
    def self.get
      TIDE_PATH
    end
  end
end
```


==TODO
- Improve documentation

==Acknowledgement
David Flatter - XTide: Harmonic tide clock and tide predictor (http://www.flaterco.com/xtide).

==License
The Tide plugin is released under the MIT license.

==Support
Any questions, enhancement proposals, bug notifications or corrections can be sent to mailto:jeff@barriault.net.
