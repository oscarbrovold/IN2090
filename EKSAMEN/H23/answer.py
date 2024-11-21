def vedlikeholdt(conn, omrade):
    cur = conn.cursor()
    q = "UPDATE sensor s " + \
        "SET s.vedlikeholdt = current_date " + \
        "WHERE s.oid = (SELECT o.oid FROM område o WHERE o.navn = %(omrade)s);"
    conn.execute(q, {'omrade' : omrade})
    conn.commit()
