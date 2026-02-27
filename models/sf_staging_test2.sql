{{ config(
    materialized="view"
) }}

with fba_returns as (

    SELECT
        cast("return_date" as date) as "f_date",
        *
    FROM {{ source('dc_frontendtest_006','asc_vahdam_fbareturnsreport') }}

),

search_terms as (

    SELECT
        cast("dataendtime" as date) as "s_date",
        *
    FROM {{ source('dc_frontendtest_006','asc_betterbeing_searchterms') }}

),

inventory_ledger as (

    SELECT
        cast("date" as date) as "i_date",
        *
    FROM {{ source('dc_frontendtest_006','asc_betterbeing_inventoryledgersummary') }}

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