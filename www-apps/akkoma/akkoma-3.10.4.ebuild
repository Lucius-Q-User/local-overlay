# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 systemd

GIT_TAG="0c6b12086a026520df746056d974f4d7c2d72697"
DESCRIPTION="Magically expressive social media"
HOMEPAGE="https://akkoma.social/"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

FAST_HTML_VER="2.2.0"
INETS_VER="9.1"
OS_MON_VER="2.9.1"
ELASTICSEARCH_VER="1.0.1"

HEX_PKGS="
mimerl@1.2.0
argon2_elixir@3.1.0
phoenix_swoosh@1.2.0
mail@0.3.0
meck@0.9.2
cowboy_telemetry@0.4.0
dialyxir@1.3.0
unsafe@1.0.1
earmark_parser@1.4.33
mint@1.5.1
comeonin@5.3.3
vex@0.9.0
elixir_make@0.6.3
gettext@0.22.3
nimble_pool@0.2.6
decimal@2.1.1
custom_base@0.2.1
cachex@3.6.0
telemetry@1.2.1
tesla@1.7.0
web_push_encryption@0.3.1
flake_id@0.1.0
bunt@0.2.1
hpax@0.1.2
cors_plug@3.0.3
pot@1.0.2
ex_doc@0.30.3
plug@1.14.2
ueberauth@0.10.5
poolboy@1.5.2
combine@0.10.0
httpoison@1.8.2
credo@1.7.0
ecto_psql_extras@0.7.12
telemetry_metrics_prometheus_core@1.1.0
nimble_parsec@1.3.1
statistex@1.0.0
mox@1.0.2
telemetry_metrics_prometheus@1.1.0
syslog@1.1.0
recon@2.5.3
swoosh@1.11.4
mime@1.6.0
phoenix_live_dashboard@0.7.2
majic@1.0.0
metrics@1.0.1
floki@0.34.3
ecto_enum@1.4.0
finch@0.16.0
makeup_erlang@0.1.2
open_api_spex@3.17.3
joken@2.6.0
gen_smtp@1.2.0
makeup@1.1.0
deep_merge@1.0.0
phoenix@1.6.16
plug_crypto@1.2.5
timex@3.7.11
idna@6.1.1
db_connection@2.5.0
parse_trans@3.3.1
phoenix_template@1.0.3
ssl_verify_fun@1.1.7
tzdata@1.1.1
expo@0.4.1
jumper@1.0.1
jason@1.4.1
certifi@2.9.0
excoveralls@0.16.1
websockex@0.4.3
http_signatures@0.1.1
phoenix_live_view@0.18.18
ex_aws@2.4.4
postgrex@0.17.2
trailing_format_plug@0.0.7
telemetry_metrics@0.6.1
mogrify@0.9.3
hackney@1.18.1
phoenix_pubsub@2.1.3
table_rex@3.1.1
connection@1.1.0
jose@1.11.6
makeup_elixir@0.16.1
ecto@3.10.3
telemetry_poller@1.0.0
eblurhash@1.2.2
plug_cowboy@2.6.1
ex_const@0.2.4
file_system@0.2.10
fast_sanitize@0.2.3
phoenix_html@3.3.1
eternal@1.2.2
poison@5.0.0
mock@0.3.8
ex_syslogger@2.0.0
cowlib@2.12.1
base62@1.2.2
sleeplocks@1.1.2
earmark@1.4.39
sweet_xml@0.7.3
erlex@0.2.6
calendar@1.0.0
castore@1.0.3
ecto_sql@3.10.1
bbcode_pleroma@0.2.0
html_entities@0.5.2
remote_ip@1.1.0
ranch@1.8.0
ex_machina@2.7.0
phoenix_view@2.0.2
ex_aws_s3@2.4.0
benchee@1.1.0
phoenix_ecto@4.4.2
oban@2.15.2
unicode_util_compat@0.7.0
cowboy@2.10.0
inet_cidr@1.0.4
bcrypt_elixir@3.0.1
nimble_options@1.0.2
fast_html@${FAST_HTML_VER}
plug_static_index_html@1.0.0
"

declare -A GIT_HEX_PKGS=(
	[elasticsearch]="https://akkoma.dev/AkkomaGang/elasticsearch-elixir.git;6cd946f75f6ab9042521a009d1d32d29a90113ca"
	[concurrent_limiter]="https://akkoma.dev/AkkomaGang/concurrent-limiter.git;a9e0b3d64574bdba761f429bb4fba0cf687b3338"
	[search_parser]="https://github.com/FloatingGhost/pleroma-contrib-search-parser.git;08971a81e68686f9ac465cfb6661d51c5e4e1e7f"
	[captcha]="https://git.pleroma.social/pleroma/elixir-libraries/elixir-captcha.git;3bbfa8b5ea13accc1b1c40579a380d8e5cfd6ad2"
	[linkify]="https://akkoma.dev/AkkomaGang/linkify.git;2567e2c1073fa371fd26fd66dfa5bc77b6919c16"
	[mfm_parser]="https://akkoma.dev/AkkomaGang/mfm-parser.git;912fba81152d4d572e457fd5427f9875b2bc3dbe"
	[temple]="https://akkoma.dev/AkkomaGang/temple.git;066a699ade472d8fa42a9d730b29a61af9bc8b59"
)

SRC_URI="
	https://github.com/Lucius-Q-User/${PN}/archive/${GIT_TAG}.tar.gz -> ${P}.tar.gz
"

for pkg in ${HEX_PKGS}; do
	name=${pkg%@*}
	version=${pkg##*@}
	url="https://repo.hex.pm/tarballs/${name}-${version}.tar"
	SRC_URI+="${url} "
done

DEPEND="
	dev-lang/elixir
	dev-util/rebar
	dev-erlang/hex
	acct-user/akkoma
	acct-group/akkoma
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_TAG}"

src_unpack() {
	unpack "${P}.tar.gz"

	tmpdir="${T}/hex_unpack"
	mkdir -p "${T}/hex_unpack" || die
	generator="${T}/genhex.exs"
	echo "packages = [" >"${generator}"
	for pkg in ${HEX_PKGS}; do
		name=${pkg%@*}
		version=${pkg##*@}
		tarfile="${DISTDIR}/${name}-${version}.tar"
		outer_dest="${tmpdir}/${name}-${version}"
		mkdir -p "${outer_dest}" || die
		tar xf "${tarfile}" -C "${outer_dest}" || die
		dest="${S}/deps/${name}"
		mkdir -p "${dest}" || die
		tar xf "${outer_dest}/contents.tar.gz" -C "${dest}" || die
		echo "  {\"${name}\", \"${version}\"}," >>"${generator}"
	done
	echo "]" >>"${generator}"
	cat >>"${generator}" <<-EOF
		Enum.each(packages, fn {name, version} ->
		  pv = name <> "-" <> version
		  dirname = "${tmpdir}/" <> pv
		  cfg = File.read!(dirname <> "/metadata.config")
		  meta = cfg |> String.split(".\n", trim: true) |> Enum.map(fn term ->
		    {:ok, tokens, _} = :erl_scan.string(String.to_charlist(term <> "."))
		    {:ok, term} = :erl_parse.parse_term(tokens)
		    term
		  end) |> Enum.into(%{})
		  hexdata = {
		    {:hex, 2, 0},
		    %{
		      name: meta["app"],
		      version: meta["version"],
		      repo: "hexpm",
		      managers: meta["build_tools"] |> Enum.map(&String.to_atom/1),
		      inner_checksum: String.downcase(File.read!(dirname <> "/CHECKSUM")),
		      outer_checksum: String.downcase(Base.encode16(:crypto.hash(:sha256, File.read!("${DISTDIR}/" <> pv <> ".tar"))))
		    }
		  }
		  File.write!("${S}/deps/" <> name <> "/.hex", :erlang.term_to_binary(hexdata))
		end)
		EOF
	elixir "${generator}" || die

	for pkg in "${!GIT_HEX_PKGS[@]}"; do
		IFS=';' read -r uri commit <<< "${GIT_HEX_PKGS[${pkg}]}"
		git-r3_fetch "${uri}" "${commit}"
		dest="${S}/deps/${pkg}/"
		git-r3_checkout "${uri}" "${dest}"
		git "--git-dir=${dest}/.git" config remote.origin.url "${uri}"
	done
}

src_compile() {
	rel_dir="${WORKDIR}/release"
	mkdir -p "${rel_dir}" || die
	MIX_ENV=prod mix release --path "${rel_dir}" || die
}

src_install() {
	rel_dir="${WORKDIR}/release"
	dest_dir="/usr/$(get_libdir)/akkoma"
	insinto "${dest_dir}"
	read erts_ver _my_ver <"${rel_dir}/releases/start_erl.data"
	for dir in lib releases; do
		doins -r "${rel_dir}/${dir}"
	done
	exeinto "${dest_dir}/bin"
	for file in "${rel_dir}/bin/"/*; do
		doexe "$file"
	done
	exeinto "${dest_dir}/erts-${erts_ver}/bin"
	for file in "${rel_dir}/erts-${erts_ver}/bin"/*; do
		doexe "$file"
	done
	dosym "${dest_dir}/bin/pleroma" "/usr/bin/pleroma"
	svc_file="${rel_dir}/installation/akkoma.service"
	sed -i -e "s:/opt/akkoma/bin:/usr/bin:g" "${svc_file}"
	sed -i -e "s:/opt/akkoma:${dest_dir}:g" "${svc_file}"
	fperms 755 "${dest_dir}/releases/${PV}/elixir"
	fperms 755 "${dest_dir}/releases/${PV}/iex"
	fperms 755 "${dest_dir}/releases/${PV}/env.sh"

	fperms 755 "${dest_dir}/lib/elasticsearch-${ELASTICSEARCH_VER}/priv/bin/wrap"
	fperms 755 "${dest_dir}/lib/fast_html-${FAST_HTML_VER}/priv/fasthtml_worker"
	fperms 755 "${dest_dir}/lib/inets-${INETS_VER}/priv/bin/runcgi.sh"
	fperms 755 "${dest_dir}/lib/os_mon-${OS_MON_VER}/priv/bin/memsup"
	fperms 755 "${dest_dir}/lib/os_mon-${OS_MON_VER}/priv/bin/cpu_sup"

	systemd_dounit "${svc_file}"
}
