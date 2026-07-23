with source as (

select 
    * 
from {{source('health_care', 'healthcare_data' )}}),

renamed as (

    select 
        patient_id,
        claim as claim_id,
        npi,
        payer,
        age,
        sex,
        bmi,
        smoker,
        systolic_bp,
        diastolic_bp,
        cholesterol,
        glucose,
        heart_rate,
        num_prior_visits,
        diagnosis,
        icd,
        cast(cpt as varchar) as cpt,
        length_of_stay_days,
        amount as claim_amount,
        claim_status,
        case when claim_status = 'Denied' then 1 else 0 end as is_denied,
        readmitted_30d,
        icd || '_' || cast(cpt as varchar) as icd_cpt_pair

        from source

)
select * from renamed