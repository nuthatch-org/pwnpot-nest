-- One row per CTF: who opened it, when, tickets sold, levels solved, and whether it was finalized.
CREATE VIEW ctf_history AS
  SELECT c."ctfId_dec" AS ctf_id, c.organizer, c.block_timestamp AS created_at,
         (SELECT count(*) FROM ctf_platform__ticket_bought t WHERE t."ctfId" = c."ctfId") AS tickets,
         (SELECT count(*) FROM ctf_platform__level_solved s WHERE s."ctfId" = c."ctfId") AS solves,
         (SELECT count(*) FROM ctf_platform__finalized f WHERE f."ctfId" = c."ctfId") > 0 AS finalized
  FROM ctf_platform__c_t_f_created c;
