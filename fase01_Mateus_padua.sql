-- Fase 1
-- 1: Endereço com maior volume de transações enviadas
SELECT AddressOrigin, COUNT(*) AS TotalTransactions FROM db_hiring_test.raw_transactions_table GROUP BY AddressOrigin
ORDER BY TotalTransactions DESC LIMIT 1;
-- A-99	90

-- 2: Dia do mês com maior volume de transações realizadas
SELECT DATE(SentDate) AS MaxMonthDay, COUNT(*) AS TotalTransactions FROM db_hiring_test.raw_transactions_table
GROUP BY MaxMonthDay ORDER BY TotalTransactions DESC LIMIT 1;
-- 2021-01-07	288

-- 3: Dia da semana com maior volume de transações realizads
WITH DayOfWeek AS (
    SELECT DAYOFWEEK(SentDate) AS MaxWeekDay, COUNT(*) AS TotalTransactions FROM db_hiring_test.raw_transactions_table
    GROUP BY MaxWeekDay ORDER BY TotalTransactions DESC LIMIT 1
),
-- listando todas as datas que correspondem ao dia da semana com o maior volume de transações
TopDayTransactions AS (
    SELECT DATE(SentDate) AS TransactionDate, COUNT(*) AS TotalTransactions FROM db_hiring_test.raw_transactions_table
    WHERE DAYOFWEEK(SentDate) = (SELECT MaxWeekDay FROM DayOfWeek)
    GROUP BY TransactionDate ORDER BY TransactionDate
)
SELECT *, (SELECT SUM(TotalTransactions) FROM TopDayTransactions) AS Total FROM TopDayTransactions;
-- 2021-01-02	240	978
-- 2021-01-09	188	978
-- 2021-01-16	164	978
-- 2021-01-23	178	978
-- 2021-01-30	208	978


-- Consulta 4: Transações com condições atípicas

-- transações com valor muito alto
SELECT * FROM db_hiring_test.raw_transactions_table
WHERE TotalSent > 1000000;

-- transações com horários atipicos: nesse caso entre meia noite e 4 da manhã
SELECT * FROM db_hiring_test.raw_transactions_table
WHERE HOUR(SentDate) BETWEEN 0 AND 4;

-- transações duplicadas
SELECT IdTransaction, AddressOrigin, AddressDestination, TotalSent, SentDate, COUNT(*) FROM db_hiring_test.raw_transactions_table
GROUP BY AddressOrigin, AddressDestination, TotalSent, SentDate HAVING COUNT(*) > 1;

-- varias transações enviadas do mesmo endereço no mesmo dia
SELECT AddressOrigin, DATE(SentDate) AS TransactionDate, COUNT(*) AS total
FROM db_hiring_test.raw_transactions_table
GROUP BY AddressOrigin, TransactionDate HAVING total > 5 ORDER BY total DESC;
-- contrario, varias transações recebidas de um só endereço
SELECT AddressDestination, DATE(SentDate) AS TransactionDate, COUNT(*) AS total
FROM db_hiring_test.raw_transactions_table
GROUP BY AddressDestination, TransactionDate HAVING total > 5 ORDER BY total DESC;


-- 5: Carteira com o maior saldo final
-- total enviado por cada carteira de origem
WITH SentTotals AS (
    SELECT AddressOrigin AS Address, SUM(TotalSent) AS TotalSent FROM db_hiring_test.raw_transactions_table
    GROUP BY AddressOrigin
),
-- total recebido por cada carteira de destino
ReceivedTotals AS (
    SELECT AddressDestination AS Address, SUM(TotalSent) AS TotalReceived FROM db_hiring_test.raw_transactions_table
    GROUP BY AddressDestination
)
-- Calcular o saldo final para cada carteira
SELECT Address,
    COALESCE(TotalSent, 0) AS TotalSent,
    COALESCE(TotalReceived, 0) AS TotalReceived,
    COALESCE(TotalSent, 0) - COALESCE(TotalReceived, 0) AS Balance -- calcula o saldo final
FROM (
    SELECT s.Address, s.TotalSent, r.TotalReceived FROM SentTotals s
    LEFT JOIN ReceivedTotals r ON s.Address = r.Address
    UNION
    SELECT r.Address, s.TotalSent, r.TotalReceived FROM ReceivedTotals r
    LEFT JOIN SentTotals s ON r.Address = s.Address
) AS combined
ORDER BY Balance DESC LIMIT 1;
-- A-99	47122	25875	total:21247
