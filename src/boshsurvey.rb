#!/usr/local/bin/ruby

def mapdeployment envname,depname,depid
  result = `gobosh -e #{envname} -d #{depname} instances`.lines.to_a
  instances = []
  result.each do |line| 
    field = line.strip.split("\t")
    instances.push(field)
  end

  instances.each_with_index do |env, i|
    if env.length >= 4 
      puts "#{depid}ins#{i} [label=\"{<f0>instance\\n" + env[0] + "|<f1>" + env[1] + "\\n" + env[2] + "\\n" + env[3] + "}\" style=filled,fillcolor=plum,shape=Mrecord];"
    end
  end
  
  instances.each_with_index do |env,i|
    puts "#{depid}ins#{i} -- #{depid}"
  end

end


def mapenvironment envname,envid
  result = `gobosh -e #{envname} deployments`.lines.to_a
  deployments = []
  result.each do |line| 
    field = line.strip.split("\t")
    deployments.push(field)
  end

  deployments.each_with_index do |env, i|
    if env.length >= 4 
      puts "#{envid}dep#{i} [label=\"{<f0>deployment\\n" + env[0] + "|<f1>" + env[1] + "\\n" + env[2] + "\\n" + env[3] + "}\" style=filled,fillcolor=lightskyblue,shape=Mrecord];"
      mapdeployment envname,env[0],envid+"dep#{i}"
    end
  end
  
  deployments.each_with_index do |env,i|
    if env.length>=4
      puts "#{envid}dep#{i} -- #{envid}"
    end
  end

end




result = `gobosh environments`.lines.to_a
environments = []
result.each do |line| 
  field = line.strip.split("\t")
  environments.push(field)
end

puts "graph boshsurvey {"
puts 'root [label="root" fillcolor=tomato,style=filled,shape=Mrecord]'
environments.each_with_index do |env, i|
  puts "env#{i} [label=\"{<f0>environment\\n" + env[1] + "|<f1>" + env[0] + "}\" style=filled,fillcolor=wheat,shape=Mrecord];"
end

environments.each_with_index do |env,i|
  puts "env#{i} -- root"
  mapenvironment env[1],"env#{i}"
end

puts "}"

