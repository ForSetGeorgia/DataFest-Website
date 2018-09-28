# DataFest-Website
Source code for [datafest.ge](https://datafest.ge)

# Building the code
There is a Ruby script at `script/generate_digest.rb` that should be called before deploying the site to the server. This script will add a digest hash to the end of the asset files (img, js, css) so that the browsers can deteect what is a new file and what is an old file, and if new, download the file. Since the asset file names change, the references to these files in the html and css pages are also updated.

To run it, you need to have ruby installed, and then run `ruby script/generate_digest.rb`.

After the script is run, all of the necessary files for the server will be located in the `build ` folder. Only these files should be copied to the server - no other files/folders at the root are necessary.