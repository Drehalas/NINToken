// test/Timelock.test.js

const Timelock = artifacts.require("Timelock");

contract("Timelock", accounts => {
    let timelockInstance;
    const owner = accounts[0];
    const nonOwner = accounts[1];
    const unlockTime = Math.floor(Date.now() / 1000) + 86400; // 1 day from now

    beforeEach(async () => {
        timelockInstance = await Timelock.new(unlockTime);
    });

    it("should set owner and unlock time correctly", async () => {
        const ownerAddress = await timelockInstance.owner();
        const unlockTimeResult = await timelockInstance.unlockTime();

        assert.equal(ownerAddress, owner, "Owner address is incorrect");
        assert.equal(unlockTimeResult.toNumber(), unlockTime, "Unlock time is incorrect");
    });

    it("should allow deposit of funds", async () => {
        const depositAmount = web3.utils.toWei("1", "ether");
        await timelockInstance.deposit({ value: depositAmount });
        const contractBalance = await web3.eth.getBalance(timelockInstance.address);

        assert.equal(contractBalance, depositAmount, "Contract balance is incorrect");
    });

    it("should not allow withdrawal before unlock time", async () => {
        const withdrawalAmount = web3.utils.toWei("1", "ether");
        try {
            await timelockInstance.withdraw(withdrawalAmount, { from: owner });
            assert.fail("Withdrawal should have failed");
        } catch (error) {
            assert(error.message.includes("Function called too early"), "Unexpected error message");
        }
    });

    it("should allow withdrawal after unlock time", async () => {
        const withdrawalAmount = web3.utils.toWei("1", "ether");
        await new Promise(resolve => setTimeout(resolve, 1000)); // Wait for 1 second
        await timelockInstance.withdraw(withdrawalAmount, { from: owner });
        const ownerBalance = await web3.eth.getBalance(owner);

        assert(ownerBalance > 0, "Owner balance should be greater than 0 after withdrawal");
    });

    it("should not allow non-owner to withdraw", async () => {
        const withdrawalAmount = web3.utils.toWei("1", "ether");
        await new Promise(resolve => setTimeout(resolve, 1000)); // Wait for 1 second
        try {
            await timelockInstance.withdraw(withdrawalAmount, { from: nonOwner });
            assert.fail("Withdrawal should have failed");
        } catch (error) {
            assert(error.message.includes("Only owner can perform this action"), "Unexpected error message");
        }
    });
});