class Hoi
  def initialize(args)
    if args > 1
      if args > 2
        if args > 3
          if args > 4
            try :hoi do
              if args > 5
                puts args if args < 10
              else
                throw :hoi
              end
            end
          end
          $hash = {
            hoi:  ->(){ 'hoi'  },
            hoi2: ->(){ 'hoi2' }
          }
        end
      end
    elsif args == 'hoi'
      puts 'hoi' unless args.length == 4
    end

    if args > 1
      if args > 2
        if args > 3
          if args > 4
            try :hoi do
              if args > 5
                puts args if args < 10
              else
                throw :hoi
              end
            end
          end
        end
      end
    elsif args == 'hoi'
      puts 'hoi' unless args.length == 4
    end
  end
end

Hoi.new(8)
