var ContratoSolicitud = artifacts.require("contratoSolicitud");
module.exports = function(deployer){
    deployer.deploy(ContratoSolicitud)
}