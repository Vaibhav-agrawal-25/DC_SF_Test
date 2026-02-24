with fba_returns as (

    select 
        cast("return_date" as date) as date,
        count(*) as return_rows,
        sum("quantity") as total_return_qty
    from asc_vahdam_fbareturnsreport
    group by 1

),

search_terms as (

    select 
        cast("dataendtime" as date) as date,
        count(*) as search_rows,
        count(distinct "searchterm") as unique_search_terms
    from dc_frontendtest_006.DC_DC_FRONTENDTEST_006.asc_betterbeing_searchterms
    group by 1

),

inventory_ledger as (

    select 
        cast("date" as date) as date,
        sum("ending_warehouse_balance") as ending_balance,
        sum("customer_shipments") as customer_shipments
    from dc_frontendtest_006.DC_DC_FRONTENDTEST_006.asc_betterbeing_inventoryledgersummary
    group by 1

)

select
    coalesce(f.date, s.date, i.date) as date,
    f.return_rows,
    f.total_return_qty,
    s.search_rows,
    s.unique_search_terms,
    i.ending_balance,
    i.customer_shipments

from fba_returns f
full outer join search_terms s
    on f.date = s.date
full outer join inventory_ledger i
    on coalesce(f.date, s.date) = i.date
order by date desc