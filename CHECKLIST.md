# eskgo – checklist de implementação (estágio 1)

Projeto Supabase: ESKGO-PROJECct (`pcscffaalvznamkfhfuy`, ca-central-1)
Site: https://eskgo-livia-fc.vercel.app (Vercel, conta livia-fc, produção)
Legenda: [x] feito e verificado · [~] feito, não verificado de ponta a ponta · [ ] pendente

## Banco
- [x] Tabelas: profiles, budget_categories, cards, transactions, goals (PK composta user_id+id, FKs, CHECKs)
- [x] Índices e trigger updated_at
- [x] RLS ligada nas 5 tabelas, 4 políticas por tabela (dono só vê o que é seu)
- [x] anon sem acesso; authenticated com CRUD limitado pela RLS
- [x] Advisors de segurança: só 1 aviso, "proteção contra senhas vazadas" desligada (item opcional abaixo)
- [x] Dados de exemplo (`seed_demo_data()`), todos com `is_demo = true`
- [x] CRUD e isolamento entre usuários validados no banco
## Acesso e login
- [x] Usuário admin `livia.ferrercruz@gmail.com` criado, e-mail confirmado, papel admin em `app_metadata`
- [x] Políticas `*_admin_all` e função `is_admin()` (admin lê e altera os dados de todos)
- [x] Front exige login: "Entrar" e "Criar conta" (e-mail + senha); "Sair" encerra a sessão
- [x] Front filtra os dados pelo usuário logado (o admin não puxa os dados dos outros por engano)
- [~] Login do admin com a senha provisória: **não testado** (meu ambiente não alcança o Supabase)
- [x] Senha provisória do admin trocada (a nova não fica registrada no repositório)
- [ ] Conferir em Supabase > Authentication: "Allow anonymous sign-ins" desligado
- [ ] Decidir "Confirm email" (ligado = mais seguro; desligado = facilita testes)
- [ ] Opcional: ativar proteção de senha vazada e exigir senha mais forte (Authentication > Policies)
## Tela inicial e cadastro
- [x] Tela de boas-vindas (foto + "Comece agora") → cadastro (nome, e-mail, senha, confirmar senha) ou login
- [x] Cadastro com e-mail já existente agora avisa "já tem conta" (antes mostrava sucesso falso)
- [ ] **Subir `girl.webp` no bucket público `brand` do Supabase Storage** (a foto da tela inicial é carregada de lá)
- [ ] Supabase > Authentication > URL Configuration: Site URL = https://eskgo-livia-fc.vercel.app (senão o link do e-mail de confirmação aponta para localhost)
- [ ] "Esqueci minha senha" ainda não existe
## Storage
- [x] Bucket público `brand` (só imagens, até 2 MB) para a arte da tela inicial
- [x] Bucket privado `avatars` (2 MB, jpeg/png/webp) com políticas por pasta do usuário
- [ ] Upload do avatar pela interface (o avatar atual é um arquivo estático do app)
## Front e Vercel
- [x] supabase-js conectado, lê e grava via Supabase
- [x] Publicado em produção, estado READY
- [~] Testar online: login, adicionar gasto, recarregar, sair, criar conta de teste
## Documentação
- [x] `prisma/schema.prisma` (documentação; use `prisma db pull`, não `migrate`)
- [x] `supabase/migrations/…admin_role_policies.sql`
## Pendências conhecidas
- [ ] Regras de saldo/fatura rodam no navegador; mover para funções RPC no banco
- [ ] Apagar cartões e metas
- [ ] Contas novas recebem dados de exemplo; trocar por conta vazia antes do lançamento real
- [ ] Limpar dados fictícios: `delete from public.transactions where is_demo;` (e o mesmo em cards, goals, budget_categories, profiles)
- [ ] Remover o papel admin quando não for mais necessário (SQL no arquivo da migration)

## Como republicar
Arraste esta pasta em vercel.com/new ou rode `npx vercel --prod`. Não há variáveis de ambiente: a URL e a chave publishable do Supabase são públicas por desenho.

- [x] Repositório no GitHub (livia-FC/Eskgo) conectado à Vercel: cada commit na `main` publica o site automaticamente
