Pensando numa arquitetura e fluxo em cloud, idealmente AWS, acredito que possam ser usadas as seguintes ferramentas:
  1 - AWS RDS: Para armazenar as tabelas de transações e taxas.
  2 - Lambda: Pra ser executada em periodos de tempo. Vão consultar o RDS para obter os dados e calcular as métricas, armazenando o resultado no S3.
  3 - S3: Armazenar os logs e relatórios. Informações brutas.
  4 - CloudWatch: Para monitorar a execução do Lambda. Podendo alertar sobre falhas no Lambda.
  5 - Amazon Athena: Realizar as consultas nos dados armazenados no S3. Sem a necessidade de carregar os dados em um banco separado.
  
![arquiteturaAWS](https://github.com/user-attachments/assets/f9593b5b-1d40-4ca6-80b6-b71346b2ce07)
