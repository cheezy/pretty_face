# pretty_face

HTML report for cucumber and rspec.  You can customize the report by editing an erb file.

The current release is very basic but you can expect a lot more over the next month or so.  If you wish to use this formatter you can simply add the following to your command-line or cucumber.yml profile:

    --format PrettyFace::Formatter::Html --out index.html
    


## Known Issues

See [http://github.com/cheezy/pretty_face/issues](http://github.com/cheezy/pretty_face/issues)

## Contribute
 
* Fork the project.
* Test drive your feature addition or bug fix. Adding specs is important and I will not accept a pull request that does not have tests.
* Make sure you describe your new feature with a cucumber scenario.
* Make sure you provide RDoc comments for any new public method you add. Remember, others will be using this gem.
* Commit, do not mess with Rakefile, version, or ChangeLog.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012-2013 Jeffrey S. Morgan. See LICENSE for details.
