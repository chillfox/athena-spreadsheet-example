const path = require('path');

module.exports = {
  entry: './srcjs/application.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist'),
  },
};
