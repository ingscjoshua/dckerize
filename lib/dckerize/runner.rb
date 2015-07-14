module Dckerize
  class Runner

    VALID_OPTIONS = ['--database=mysql', '--database=postgres', '--database=mongo', '--extras=elasticsearch']
    ERROR_MESSAGE = 'USAGE: dckerize up APP_NAME --database=[mysql|postgres|mongo] [--extras=elasticsearch]'
    def initialize(options)
      @options = options
    end

    def execute
      extras = []
      db = ''
      raise ERROR_MESSAGE unless valid?
      @options[2..-1].each do |option|
        splitted_option = option.split('=')
        if splitted_option[0] == '--database'
          db = splitted_option[1]
        elsif splitted_option[0] == '--extras'
          extras << splitted_option[1].split(',')
        else
          raise_error ERROR_MESSAGE
        end
      end
      Dckerize::Generator.new(@options[1], db, extras.flatten).up
    end

    def valid?
      # first option should always be up
      return false if @options[0] != 'up'
      # db is mandatory
      return false unless @options.grep(/--database=/).any?
      # only valid options allowed
      @options[2..-1].each do |option|
        return false unless VALID_OPTIONS.include?(option)        
      end
      true
    end
  end

end
