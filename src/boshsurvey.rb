#!/usr/local/bin/ruby


def mapenvironment envname,envid
  result = `gobosh -e #{envname} deployments`.lines.to_a
  deployments = []
  result.each do |line| 
    field = line.strip.split("\t")
    deployments.push(field)
  end

  deployments.each_with_index do |env, i|
    if env.length >= 4 
      puts "#{envid}dep#{i} [label=\"{<f0>" + env[0] + "|<f1>" + env[1] + "\\n" + env[2] + "\\n" + env[3] + "}\" shape=Mrecord];"
    end
  end
  
  deployments.each_with_index do |env,i|
    puts "#{envid}dep#{i} -- #{envid}"
  end

end




result = `gobosh environments`.lines.to_a
environments = []
result.each do |line| 
  field = line.strip.split("\t")
  environments.push(field)
end

puts "graph boshsurvey {"
puts 'root [label="root" shape=Mrecord]'
environments.each_with_index do |env, i|
  puts "env#{i} [label=\"{<f0>" + env[1] + "|<f1>" + env[0] + "}\" shape=Mrecord];"
end

environments.each_with_index do |env,i|
  puts "env#{i} -- root"
  mapenvironment env[1],"env#{i}"
end

puts "}"

