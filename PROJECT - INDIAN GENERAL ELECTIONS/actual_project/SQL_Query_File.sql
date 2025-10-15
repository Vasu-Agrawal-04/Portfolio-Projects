use Indian_General_Elections_db;

select * from constituencywise_details;
select count(*) as total_count from constituencywise_details;

select * from constituencywise_results;
select count(*) from constituencywise_results;

select * from partywise_results;
select count(*) from partywise_results;

select * from statewise_results;
select count(*) from statewise_results;

select * from states;
select count(*) from states;

--determine the total number of seats in Lok-Sabha
select distinct count(*) as total_seat_count from constituencywise_results; 

--determine the total number of seats available for elections in each state
select s.State_ID as state_id, s.State as state_name, count(*) as total_seat_count 
from states s join statewise_results sw on s.State_ID = sw.State_ID
group by s.State_ID, s.State;

--determine the total number of seats won by NDA Alliance
SELECT SUM(CASE WHEN party IN ('Bharatiya Janata Party - BJP', 'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)', 'Shiv Sena - SHS', 'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 'Asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP', 'Janata Dal  (Secular) - JD(S)','Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP','Rashtriya Lok Dal - RLD', 'Sikkim Krantikari Morcha - SKM'
) THEN [Won] ELSE 0 END) AS NDA_Total_Seats_Won FROM partywise_results;


--determine the total number of seats won by NDA Alliance Parties
select party as Party_Name, won as seats_won from partywise_results where party in (
'Bharatiya Janata Party - BJP', 'Telugu Desam - TDP', 'Janata Dal  (United) - JD(U)','Shiv Sena - SHS', 
'AJSU Party - AJSUP', 'Apna Dal (Soneylal) - ADAL', 'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS', 'Janasena Party - JnP','Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV','Nationalist Congress Party - NCP','Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM') order by seats_won desc;

--determine the total number of seats won by I.N.D.I.A
SELECT SUM(CASE WHEN party IN ('Indian National Congress - INC','Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC','Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)','Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK','Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN','Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN','Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK','Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD','Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP','Samajwadi Party - SP','Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK') THEN [Won] ELSE 0 END) AS INDIA_Total_Seats_Won FROM 
partywise_results;

--determine the total number of seats won by I.N.D.I.A alliance parties
SELECT (CASE WHEN party IN ('Indian National Congress - INC','Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC','Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)','Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK','Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN','Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN','Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK','Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD','Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP','Samajwadi Party - SP','Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
) THEN [Won] ELSE 0 END) AS NDA_Total_Seats_Won FROM partywise_results;

--add a new columns to the partywise_results to get the party alliance as NDA, INDIA and other
alter table partywise_results add party_alliance varchar(50);
update partywise_results set party_alliance = 'I.N.D.I.A' where party in ('Indian National Congress - INC','Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC','Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)','Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK','Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN','Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN','Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK','Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD','Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP','Samajwadi Party - SP','Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK');


update partywise_results set party_alliance = 'N.D.A' where party in ('Bharatiya Janata Party - BJP', 'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)', 'Shiv Sena - SHS', 'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 'Asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP', 'Janata Dal  (Secular) - JD(S)','Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP','Rashtriya Lok Dal - RLD', 'Sikkim Krantikari Morcha - SKM');

update partywise_results set party_alliance = 'OTHERS' where party_alliance is NULL;

select party_alliance, sum(won) as total_seats from partywise_results group by party_alliance
order by total_seats desc;

--determine winning candidate's name, their party name, total votes, the margin of victory votes for a 
--specific state and constituency
select * from constituencywise_results;
select * from partywise_results;
select cwr.Winning_Candidate, pwr.Party, cwr.Total_Votes, cwr.Margin, st.state, cwr.constituency_name, 
pwr.party_alliance from constituencywise_results cwr inner join partywise_results pwr on cwr.Party_ID = pwr.Party_ID 
inner join statewise_results swr on cwr.parliament_constituency = swr.parliament_constituency
inner join states st on swr.State_ID = st.State_ID 
where st.state = 'GUJARAT';

--determine the distribution of EVM Votes verses postal votes for candidates in a specific constituency
--& also the rank in which they received highest number of votes desc
select cwd.Candidate,cwd.EVM_Votes, cwd.Postal_Votes,cwd.Total_Votes, 
cwr.Constituency_name, 
rank() over (order by cwd.Total_Votes desc) as rnk from constituencywise_details cwd inner join 
constituencywise_results cwr on cwd.Constituency_ID = cwr.Constituency_ID
where constituency_name like 'AHMEDABAD%';


--determine which parties won most seats in a state, and how manys eats they won?
select pwr.Party, count(cwr.Constituency_ID) as total_seats_won from constituencywise_results cwr join
partywise_results pwr on cwr.Party_ID = pwr.Party_ID join statewise_results swr on 
cwr.Parliament_Constituency = swr.Parliament_Constituency join states st on 
swr.State_ID = st.State_ID where st.state = 'GUJARAT' group by pwr.Party order by total_seats_won desc;

--Determine the total number of seats won by each party alliance in each state.
select st.state, 
sum(case when pwr.party_alliance = 'I.N.D.I.A' then 1 else 0 end) as INDIA_Seats_Won, 
sum(case when pwr.party_alliance = 'N.D.A' then 1 else 0 end) as NDA_Seats_Won, 
sum(case when pwr.party_alliance = 'OTHERS' then 1 else 0 end) as Others_Seats_Won 
from constituencywise_results cwr join partywise_results pwr on cwr.Party_ID = pwr.Party_ID
join statewise_results swr on cwr.Parliament_Constituency = swr.Parliament_Constituency
join states st on st.State_ID = swr.State_ID group by st.state;

--Determine which candidates received the highest number of EVM votes in each constituency(Top 10)?
select top 10 cwr.Constituency_name, cwd.constituency_ID, cwd.Candidate, cwd.EVM_Votes from 
constituencywise_details cwd join constituencywise_results cwr 
on cwr.Constituency_ID = cwd.Constituency_ID where
cwd.EVM_Votes = (select MAX(cwd1.EVM_Votes) from 
constituencywise_details cwd1 where cwd1.Constituency_ID = cwd.Constituency_ID)
order by cwd.EVM_Votes desc;

--Determine the candidate who won and the runner up in each constituency?
with rank_candidates as(
select cwd.Constituency_ID, cwd.Candidate, cwd.Party, cwd.EVM_Votes, cwd.Postal_Votes, 
cwd.EVM_Votes + cwd.Postal_Votes as total_votes, row_number() over (partition by cwd.constituency_ID order by 
cwd.EVM_Votes + cwd.Postal_Votes desc) as voterank from constituencywise_details cwd join 
constituencywise_results cwr on cwd.Constituency_ID = cwr.Constituency_ID join 
statewise_results swr on cwr.Parliament_Constituency = swr.Parliament_Constituency join 
states st on st.State_ID = swr.State_ID where st.state = 'Gujarat')
select cwr.constituency_name, 
max(case when rc.voterank = 1 then rc.Candidate end) as Winning_Candidate,
max(case when rc.voterank = 2 then rc.Candidate end) as Runnerup_Candidate
from rank_candidates rc join constituencywise_results cwr on rc.Constituency_ID = cwr.Constituency_ID
group by cwr.Constituency_Name order by cwr.Constituency_Name;

--Determine for the state of Maharashtra, what are the total number of seats, 
--total number of candidates, total number of parties, total_votes, and breakdown of evm & postal votes?

select count(distinct cwr.constituency_ID) as total_seat_count, 
count(distinct cwd.Candidate) as total_candidates, 
count(distinct cwd.Party) as total_parties,
sum(cwd.EVM_Votes+cwd.Postal_Votes) as total_votes,
sum(cwd.EVM_Votes) as total_EVM_votes, sum(cwd.Postal_Votes) as total_postal_votes
from constituencywise_results cwr join constituencywise_details cwd on 
cwd.Constituency_ID = cwr.Constituency_ID join statewise_results swr on cwr.Parliament_Constituency = 
swr.Parliament_Constituency join states st on swr.State_ID = st.State_ID where st.state = 'MAHARASHTRA';