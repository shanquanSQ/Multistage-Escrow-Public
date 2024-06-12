const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// Wallet Values from local hardhat node
ARBITER_WALLET = "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266";
BENEFICIARY_WALLET = "0x70997970c51812dc3a010c7d01b50e0d17dc79c8";
DEPOSITOR_WALLET = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";

module.exports = buildModule("Escrow", (m) => {
  const escrow = m.contract("MultiStageEscrow", [
    ARBITER_WALLET,
    BENEFICIARY_WALLET,
    DEPOSITOR_WALLET,
    [1000000000000000000n, 250000000000000000n, 250000000000000000n],
    [false, false, false], // Initialises Payments to be false.
  ]);

  m.call(escrow, "logging", []);

  return { escrow };
});
