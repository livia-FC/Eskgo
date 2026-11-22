-- Conta nova nasce vazia: só perfil e os 4 tetos de orçamento (sem dados de exemplo).
create or replace function public.init_empty_account(p_name text)
returns void
language plpgsql
set search_path = ''
as $$
declare uid uuid := (select auth.uid());
begin
  if uid is null then raise exception 'Não autenticado'; end if;
  if exists (select 1 from public.profiles where id = uid) then return; end if;

  insert into public.profiles (id, full_name, email, balance, next_id, is_demo)
  values (uid, left(coalesce(nullif(trim(p_name), ''), 'Você'), 40), (select auth.jwt() ->> 'email'), 0, 1, false);

  insert into public.budget_categories (user_id, name, cap, is_demo) values
    (uid, 'Alimentação', 1000, false), (uid, 'Moradia', 900, false),
    (uid, 'Transporte', 500, false),   (uid, 'Lazer', 800, false);
end $$;

revoke all on function public.init_empty_account(text) from public, anon;
grant execute on function public.init_empty_account(text) to authenticated;
