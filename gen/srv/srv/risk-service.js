// Imports
const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {
    // define entities from risk-service.cds
    const { Risks, BusinessPartners } = this.entities;

    // Set criticality after a READ on /risks
    this.after("READ", Risks, (data) => {
        const risks = Array.isArray(data) ? data : [data];

        risks.forEach((risk) => {
            if (risk.impact >= 100000) {
                risk.criticality = 1;
            } else {
                risk.criticality = 2;
            }
        });
    });

    // connection to the remote service
    const BPsrv = await cds.connect.to("API_BUSINESS_PARTNER");

    // Each request to the API Business Hub requires th apikey in the header
    this.on('READ', BusinessPartners, async (req) => {
        // exclude business partners without names
        req.query.where("LastName <> '' and FirstName <> '' ");

        // srv.transaction - ?????????????????????????????
        return await BPsrv.transaction(req).send({
            query: req.query,
            headers: {
                apikey: process.env.apikey
            }
        })
    })

    this.on("READ", Risks, async (req, next) => {
        console.log(req);

        try {
            const res = await next();
            console.log(res);
            await Promise.all(
                res.map(async (risk) => {
                    const bp = await BPsrv.transaction(req).send({
                        query: SELECT.one(this.entities.BusinessPartners)
                            .where({ BusinessPartner: risk.bp_BusinessPartner })
                            .columns(["BusinessPartner", "LastName", "FirstName"]),
                        headers: {
                            apikey: process.env.apikey
                        }
                    });
                    risk.bp = bp;
                })
            )
        } catch (error) { }
    });
});