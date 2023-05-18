var ContratoPrestamo = artifacts.require("contratoPrestamo");
module.exports = function(deployer){
    deployer.deploy(ContratoPrestamo)
}