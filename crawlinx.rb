#!/usr/bin/ruby1.8

require 'net/http'
require 'uri'
require 'rexml/document'


initial_url = URI.parse ARGV[0]
limit_url = URI.parse ARGV[1]

urls = Array.new
urls << initial_url		 

begin
	current_url = urls.shift
	current_url.route_from(limit_url)

	begin
	page = REXML::Document.new(Net::HTTP.get(current_url))

	rescue REXML::ParseException
		puts "erreur XML dans " + current_url
		next
	end

	# extract urls
	page.elements.each('//a[@href]') do |anchor|
		url = URI.parse(anchor.attributes['href'])
		if url.relative? 
		then 
			url = current_url + url
		end

		urls << url
	end

	urls.uniq!
	
	# print urls
	urls.each do |url|
		puts url
	end

end while not urls.empty?
