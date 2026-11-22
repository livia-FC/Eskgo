-- Papel admin vem de app_metadata.role no JWT (só o servidor altera).
create or replace function public.is_admin() returns boolean
language sql stable set search_path = '' as $$
  select coalesce((select auth.jwt() -> 'app_metadata' ->> 'role'), '') = 'admin'
$$;
revoke execute on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated;

do $$ declare t text; begin
  foreach t in array array['profiles','budget_categories','cards','transactions','goals'] loop
    execute format('create policy %I on public.%I for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()))', t||'_admin_all', t);
  end loop;
end $$;

-- Dar o papel admin a alguém (rode como dono do projeto):
-- update auth.users set raw_app_meta_data = raw_app_meta_data || '{"role":"admin"}' where email = 'EMAIL';
-- Remover: update auth.users set raw_app_meta_data = raw_app_meta_data - 'role' where email = 'EMAIL';
