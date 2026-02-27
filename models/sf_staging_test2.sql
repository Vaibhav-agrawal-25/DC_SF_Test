{{ config(
    materialized="view"
) }}

with fba_returns as (

    SELECT
        cast("return_date" as date) as "f_date",
        *
    FROM dc_frontendtest_006.DC_DC_FRONTENDTEST_006.ASC_VAHDAM_FBARETURNSREPORT

),

search_terms as (

    SELECT
        cast("dataendtime" as date) as "s_date",
        *
    FROM dc_frontendtest_006.DC_DC_FRONTENDTEST_006.ASC_BETTERBEING_SEARCHTERMS

),

inventory_ledger as (

    SELECT
        cast("date" as date) as "i_date",
        *
    FROM dc_frontendtest_006.DC_DC_FRONTENDTEST_006.ASC_BETTERBEING_INVENTORYLEDGERSUMMARY

),

finalTable as (

    select
        coalesce(fba_returns."f_date", search_terms."s_date", inventory_ledger."i_date") as "unified_date",

        fba_returns.*,
        search_terms.*,
        inventory_ledger.*

    from fba_returns

    full outer join search_terms
        on fba_returns."f_date" = search_terms."s_date"

    full outer join inventory_ledger
        on coalesce(fba_returns."f_date", search_terms."s_date") = inventory_ledger."i_date"

)

select * from finalTable