using {riskmanagement as rm} from '../db/schema';

// RiskService expose at URL path service/risk
@path : 'service/risk'
service RiskService {
    // entity Risks      as projection on rm.Risks;
    entity Risks @(restrict : [
        {
            grant : ['READ'],
            to    : ['RiskViewer']
        },
        {
            grant : ['*'],
            to    : ['RiskManager']
        }
    ])                      as projection on rm.Risks;

    annotate Risks with @odata.draft.enabled;
    entity Mitigations @(restrict : [
        {
            grant : ['READ'],
            to    : ['RiskViewer']
        },
        {
            grant : ['*'],
            to    : ['RiskManager']
        }
    ])                      as projection on rm.Mitigations;
    // entity Mitigations            as projection on rm.Mitigations;
    annotate Mitigations with @odata.draft.enabled;
    entity BusinessPartners as projection on rm.BusinessPartners;
}