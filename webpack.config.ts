import path from 'path';
import webpack from 'webpack';
import TerserPlugin from 'terser-webpack-plugin';
import CopyWebpackPlugin from 'copy-webpack-plugin';

const baseConfig: webpack.Configuration = {
  mode: 'production',
  target: 'node',
  resolve: {
    modules: [
        'node_modules',
    ]
  },
  node: {
    __dirname: false,
  },
  optimization: {
    minimizer: [new TerserPlugin({
      extractComments: false,
      terserOptions: {
        format: {
          comments: false,
        },
      },
    })],
  },
}

const config1p: webpack.Configuration = Object.assign({}, baseConfig, {
  entry: './src/first-party/index.ts',
  output: {
    path: path.resolve(__dirname, 'dist/first-party'),
    filename: 'bundle.js',
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        { from: './src/first-party/static', to: 'static' }
      ]
    })
  ],
});

const config3p: webpack.Configuration = Object.assign({}, baseConfig, {
  entry: './src/third-party/index.ts',
  output: {
    path: path.resolve(__dirname, 'dist/third-party'),
    filename: 'bundle.js',
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        { from: './src/third-party/static', to: 'static' }
      ]
    })
  ],
});

export default [ config1p, config3p ];