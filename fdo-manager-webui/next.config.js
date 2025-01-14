const { i18n } = require("./next-i18next.config");

module.exports = {
  i18n,
  transpilePackages: ["@refinedev/nextjs-router"],
  output: "standalone",
  env: {
    KEY_CLOAK_ISSUER: process.env.KEY_CLOAK_ISSUER,
    KEY_CLOAK_CLIENT_SECRET: process.env.KEY_CLOAK_CLIENT_SECRET,
    KEY_CLOAK_CLIENT_ID: process.env.KEY_CLOAK_CLIENT_ID,
    PORT: process.env.PORT,
    NEXTAUTH_URL: process.env.NEXTAUTH_URL,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
};
