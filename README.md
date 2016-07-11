# SpeechToAudioFile
Simple (quick &amp; dirty) tool to convert some text into an AIFF file using Apple's Speech Synthesiser.

Configure the following 3 switches when converting a file:

- -t "text to translate"
- -o "path to output file"
- -l "locale to use for translation"

I use this project with a small Ruby script to parse some JSON files and convert the appropriate strings into audio files.

``` ruby
#!/usr/bin/env ruby

require 'json'

root_dir = "Exercises"

lessons = Dir.entries(root_dir).reject{|f| File.file?(f) | f[0].include?('.')}
lessons.each do |lesson| 
	lesson_dir = root_dir + '/' + lesson

	exercises = Dir.entries(lesson_dir).reject{|f| File.file?(f) | f[0].include?('.')}
	exercises.each do |exercise|
		config_file = lesson_dir + '/' + exercise + '/' + 'config.json'

		if File.file?(config_file) 
			json_string = File.read(config_file)
			config = JSON.parse(json_string)
			text = "#{config['word']['th']}"

			filename = 'audio.aiff'
			output_file = lesson_dir + '/' + exercise + '/' + filename
			`./SpeechToAudioFile -t "#{text}" -l "th-TH" -o "#{output_file}"`
		end
	end
end
```

