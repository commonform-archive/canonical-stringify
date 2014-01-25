module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        options:
          sourceMap: true
        files:
          '<%= pkg.name %>.js': '<%= pkg.name %>.coffee'

    uglify:
      options:
        sourceMap: true
      build:
        src: '<%= pkg.name %>.js'
        dest: '<%= pkg.name %>.min.js'

    clean: [
      '<%= pkg.name %>.js'
      '<%= pkg.name %>.js.map'
      '<%= pkg.name %>.min.js'
      '<%= pkg.name %>.min.map'
      'test/stringify.js'
    ]

    mochaTest:
      test:
        options:
          mocha: require 'mocha'
          require: [
            'coffee-script'
            'should'
          ]
          reporter: 'spec'
        src: ['test/**/*.coffee']

  packages = [
    'grunt-contrib-coffee'
    'grunt-contrib-uglify'
    'grunt-contrib-clean'
    'grunt-mocha-test'
  ]
  grunt.loadNpmTasks p for p in packages

  grunt.registerTask 'default', ['build']
  grunt.registerTask 'build', ['coffee', 'uglify']
  grunt.registerTask 'test', ['mochaTest']
