require "model_quiz/version"
require 'find'

module ModelQuiz

  def self.quiz_me
    hash = {}

    Find.find('app/models') do |path|
      next unless path.end_with?('.rb')

      key = ''
      File.readlines(path).each do |line|
        line.match(/class (\S*) \< ActiveRecord::Base/) do |matches|
          key = matches[1] if matches[1]
        end

        if key
          line.match(/\A\s*(belongs_to|has_many|has_one)\s+:(\w*)/) do |matches|
            hash[key] ||= []
            hash[key] << matches.to_a.slice(1..-1)
          end
        end
      end
    end

    while true
      model = hash.keys.shuffle.last
      relationship, attribute = hash[model].shuffle.last
      attribute.gsub! /s\Z/, ''
      puts '#' * 50
      puts "#{model} _________________ #{attribute}"
      STDIN.gets
      puts relationship
      STDIN.gets
    end

  end

end
