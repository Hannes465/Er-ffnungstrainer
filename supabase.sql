-- Eröffnungstrainer: Speicher pro Konto.
-- Einmal im Supabase-Dashboard unter "SQL Editor" ausführen.

create table if not exists public.eroeffnungen_docs (
  user_id    uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  key        text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);

-- Jeder sieht und ändert nur seine eigenen Zeilen.
alter table public.eroeffnungen_docs enable row level security;

drop policy if exists "eigene lesen"    on public.eroeffnungen_docs;
drop policy if exists "eigene anlegen"  on public.eroeffnungen_docs;
drop policy if exists "eigene ändern"   on public.eroeffnungen_docs;
drop policy if exists "eigene löschen"  on public.eroeffnungen_docs;

create policy "eigene lesen"   on public.eroeffnungen_docs for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "eigene anlegen" on public.eroeffnungen_docs for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "eigene ändern"  on public.eroeffnungen_docs for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "eigene löschen" on public.eroeffnungen_docs for delete to authenticated
  using ((select auth.uid()) = user_id);

revoke all on public.eroeffnungen_docs from anon;
grant select, insert, update, delete on public.eroeffnungen_docs to authenticated;
