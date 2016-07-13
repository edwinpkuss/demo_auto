require 'logger'
require 'spec_helper'
require 'thread'

module LogFactory
  extend Capybara::DSL
    def pc_logger(level)
      @logger = Logger.new(STDOUT)
      debug_log = File.new(File.join(File.dirname(__FILE__), "/Debug.log"), "a")
      @logger_file = Logger.new(debug_log)
      case level
        when "debug"
          @logger.level = Logger::DEBUG && @logger_file.level = Logger::DEBUG
        when "info"
          @logger.level = Logger::INFO && @logger_file.level = Logger::INFO
        when "error"
          @logger.level = Logger::ERROR && @logger_file.level = Logger::ERROR
      end
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "##{datetime}##{progname}[#{severity}]#{msg}\n"
      end
      @logger_file.formatter = proc do |severity, datetime, progname, msg|
        "##{datetime}##{progname}[#{severity}]#{msg}\n"
      end
    end

    def pre_write_log
      @case_name_array = []
      @case_owner_array = []
      @case_path_array = []
      @case_result_array = []
      @case_pending = []
      @mutex = Mutex.new
    end

    def after_write_log
      #save_screenshot
      pass_file_path = File.join(File.dirname(__FILE__), "../tmp/summary_pass.html")
      fail_file_path = File.join(File.dirname(__FILE__), "../tmp/summary_fail.html")
      @pass_file = File.new(pass_file_path, "a")
      @fail_file = File.new(fail_file_path, "a")
      (0..@case_name_array.length-1).each do |c|
        status = @case_result_array[c].status.id2name
        if status =~ /pass/i
          print_pass_log @pass_file, @case_name_array[c],@case_owner_array[c],@case_result_array[c],status
        elsif status =~ /fail/i
          print_failed_log @fail_file, @case_name_array[c],@case_owner_array[c],@case_result_array[c],status
          print_all_failed_logs @case_result_array[c], @case_name_array[c]
        else
          raise "Status cannot be recognized."
        end
      end
    end

    def print_pass_log pass_file,name,owner,result,status
      pass_file.puts "<tr>"
      pass_file.puts "<td>#{name}</td>"
      pass_file.puts "<td>#{owner}</td>"
      pass_file.puts "<td>#{result.run_time.to_s}" + " s" + "</td>"
      pass_file.puts "<td>#{status}" + "</td>"
      pass_file.puts "</tr>"
    end

    def print_failed_log fail_log,name,owner,result,status
      fail_log.puts "<tr>"
      fail_log.puts "<td><a href=\"##{name}\">#{name}</a></td>"
      fail_log.puts "<td>#{owner}</td>"
      fail_log.puts "<td>#{result.run_time.to_s}" + " s" + "</td>"
      fail_log.puts "<td>#{status}" + "</td>"
      fail_log.puts "</tr>"
    end

    def print_all_failed_logs a,name
      detailed_log = File.join(File.dirname(__FILE__), "../tmp/summary_detail.html")
      @b = File.new(detailed_log, "a")
      @b.puts "<span id=\"#{name}\">Test case: #{name}</span>"
      name = name.gsub(" ","_")
      name = name.gsub("/","_")
      id = name + "_1"
      @b.puts "<div><a href onclick=\"img=document.getElementById('#{id}'); img.style.display = (img.style.display == 'none' ? 'block' : 'none');return false\">screen: #{name}</a></div>"
      @b.puts "<img id=\"#{id}\" src=\"../screen/#{name}.png\" style=\"display: none;\"/>"
      @b.puts "<div>error_message: #{a.exception.class}</div>"
      @b.puts "<div>#{a.exception.message}</div>"
      a.exception.backtrace.each do |m|
        @b.puts "<div>#{m}</div>"
      end
    end
end