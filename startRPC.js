const TestRPC = require("ethereumjs-testrpc");

const server = TestRPC.server({
  accounts: [
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
    {
      balance: 0xd3c21bcecceda0000000
    },
  ],
  debug: true,
  logger: console
});

server.listen(8545);