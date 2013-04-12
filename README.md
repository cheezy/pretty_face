# pretty_face

HTML report for cucumber and rspec.  You can customize the report by editing an erb file.

The current release is very basic but you can expect a lot more over the next month or so.  If you wish to use this formatter you can simply add the following to your command-line or cucumber.yml profile:

    --format PrettyFace::Formatter::Html --out index.html
    
## Customizing the report

Starting with version 0.3 of the gem you can customize some elements on the report.  You will do this by first creating a directory named `pretty_face` in the `features/support` directory.  Customization files should be placed in this directory.

### Changing the image on all pages

To replace the image that appears at the top of all pages you simply need to place a file in the customization directory named `logo.png`.  The extention can be png, gif, jpg, or jpeg but the filename must be logo in all lower case.  The image will look best if it is around 220 X 220 pixels.

### Replacing the header on the main landing page

To replace the header that appears at the top of the main landing page you simply need to create a file in the customization directory that contains the html you wish to display.  The file must be named `_suite_header.erb`.

### Replacing the header on the feature pages

To replace the header that appears on all of the pages with details about features you simply need to create a file in the customization directory that contains the html you wish to display.  The file must be named `_feature_header.erb`.

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
