with fba_returns as (

    select
        cast("return_date" as date) as "f_date",
        *
    from {{ source('dc_frontendtest_006','asc_vahdam_fbareturnsreport') }}

),

search_terms as (

    select
        cast("dataendtime" as date) as "s_date",
        *
    from {{ source('dc_frontendtest_006','asc_betterbeing_searchterms') }}

),

inventory_ledger as (

    select
        cast("date" as date) as "i_date",
        *
    from {{ source('dc_frontendtest_006','asc_betterbeing_inventoryledgersummary') }}

),

final as (

    select
        coalesce(f."f_date", s."s_date", i."i_date") as "unified_date",

        f.*,
        s.*,
        i.*

    from fba_returns f

    full outer join search_terms s
        on f."f_date" = s."s_date"

    full outer join inventory_ledger i
        on coalesce(f."f_date", s."s_date") = i."i_date"

)

select *
from final