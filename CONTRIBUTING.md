When adding code to this plugin, please follow those simple rules when writing
the code:

* Write good commit messages. An explanation of good commit message as I see it
    can be found [here](https://commit.style/) or
    [here](https://chris.beams.io/posts/git-commit/).
* Follow the code conventions. There are some conventions that the code follows,
    keep following them as best as you can. Most of the conventions can be
    understood from reading the code, but some basic guidelines:
    * Wrap your lines at around 80 characters.
    * Add {{{ and }}} around every function in your code, making it collapsible
      using vim's marker option. Add the name of the function in both the
      opening and the closing parenthesis.
      * Add those markers to big parts of files if you add more then mere
        functions.
    * Document your function using doxygen style. (If you have better suggestion
      for vim code documentation, you are more than welcome to contact me!).
* In case you change the interface of the plugin, be sure to add explanation
    about it in the [readme](README.md) and [dos](doc/auto-abbrev.txt).

