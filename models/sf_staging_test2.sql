{{ config(
    materialized="view"
) }}


with fba_returns as (

    SELECT * 
    FROM dc_frontendtest_006.DC_DC_FRONTENDTEST_006.ASC_VAHDAM_FBARETURNSREPORT

),

search_terms as (

    SELECT * 
    FROM dc_frontendtest_006.DC_DC_FRONTENDTEST_006.ASC_BETTERBEING_SEARCHTERMS

),

inventory_ledger as (

    SELECT * 
    FROM dc_frontendtest_006.DC_DC_FRONTENDTEST_006.ASC_BETTERBEING_INVENTORYLEDGERSUMMARY

),

finalTable as (

    select
        coalesce(
            cast(fba_returns."return_date" as date),
            cast(search_terms."dataendtime" as date),
            cast(inventory_ledger."date" as date)
        ) as "unified_date",

        fba_returns."seller_name",
        fba_returns."fnsku",
        fba_returns."asin",

        search_terms."searchterm",
        search_terms."clickedasin",
        search_terms."marketplace_id",

        inventory_ledger."title",
        inventory_ledger."msku"

    from fba_returns

    full outer join inventory_ledger
        on fba_returns."return_date" = inventory_ledger."date"

    full outer join search_terms
        on fba_returns."return_date" = search_terms."dataendtime"

)

select * from finalTable