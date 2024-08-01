-- Fase 2
-- 1: Carteira responsável pelo maior pagamento de taxas em janeiro de 2021
SELECT AddressOrigin, SUM(TotalSent * `fee-percentage` / 100) AS TotalFee
FROM db_hiring_test.raw_transactions_table t
JOIN db_hiring_test.raw_transactions_fee f ON t.TotalSent BETWEEN f.`range-start` AND f.`range-end`
WHERE MONTH(SentDate) = 1 AND YEAR(SentDate) = 2021
GROUP BY AddressOrigin ORDER BY TotalFee DESC LIMIT 1;
-- A-99	4712.200000000001

-- 2: Carteira responsável pel maior pagamento de taxas em fevereiro de 2021
SELECT AddressOrigin, SUM(TotalSent * `fee-percentage` / 100) AS TotalFee
FROM db_hiring_test.raw_transactions_table t
JOIN db_hiring_test.raw_transactions_fee f ON t.TotalSent BETWEEN f.`range-start` AND f.`range-end`
WHERE MONTH(SentDate) = 2 AND YEAR(SentDate) = 2021
GROUP BY AddressOrigin ORDER BY TotalFee DESC LIMIT 1;
-- A-91	304.6

-- 3:ID da transação com maior taxa paga
SELECT IdTransaction, TotalSent * `fee-percentage` / 100 AS MaxFee
FROM db_hiring_test.raw_transactions_table t
JOIN db_hiring_test.raw_transactions_fee f ON t.TotalSent BETWEEN f.`range-start` AND f.`range-end`
ORDER BY MaxFee DESC LIMIT 1;
-- 'ID2794', '99.9'

-- 4: Média de taxa paga
SELECT AVG(TotalSent * `fee-percentage` / 100) AS AvgFee
FROM db_hiring_test.raw_transactions_table t
JOIN db_hiring_test.raw_transactions_fee f ON t.TotalSent BETWEEN f.`range-start` AND f.`range-end`;
-- '49.55438795336788'

