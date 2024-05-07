import path from "node:path";
import ShebangPlugin from "webpack-shebang-plugin";

const __dirname = import.meta.dirname;

console.warn({ __dirname });

const config = {
  entry: "./node/src/fo.ts",
  output: {
    path: path.join(__dirname, "tmp/node/built"),
    filename: "jh-fo"
  },
  mode: "development",
  target: "node",
  module: {
    rules: [
      {
        test: /\.ts(x)?$/,
        loader: "ts-loader",
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"]
  },
  plugins: [
    /* eslint-disable @typescript-eslint/no-unsafe-call */
    new ShebangPlugin()
  ]
};

console.warn(config);

export default config;
