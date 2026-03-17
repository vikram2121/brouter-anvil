package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/BSVanon/Anvil/internal/config"
)

func main() {
	configPath := flag.String("config", "anvil.toml", "path to config file")
	flag.Parse()

	cfg, err := config.Load(*configPath)
	if err != nil {
		log.Fatalf("config: %v", err)
	}

	log.Printf("anvil node %q starting", cfg.Node.Name)
	log.Printf("  data_dir:   %s", cfg.Node.DataDir)
	log.Printf("  mesh:       %s", cfg.Node.Listen)
	log.Printf("  api:        %s", cfg.Node.APIListen)
	log.Printf("  bsv nodes:  %v", cfg.BSV.Nodes)
	log.Printf("  arc:        enabled=%v", cfg.ARC.Enabled)
	log.Printf("  junglebus:  enabled=%v", cfg.JungleBus.Enabled)
	log.Printf("  overlay:    enabled=%v topics=%v", cfg.Overlay.Enabled, cfg.Overlay.Topics)

	// TODO: Phase 1 — init BRC identity from cfg.Identity.WIF
	// TODO: Phase 2 — start P2P transport, header sync
	// TODO: Phase 3 — start TX relay
	// TODO: Phase 4 — start gossip mesh
	// TODO: Phase 5 — init envelope store
	// TODO: Phase 5.5 — init wallet
	// TODO: Phase 6 — start overlay discovery
	// TODO: Phase 7 — start REST API

	// Block until signal
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	s := <-sig
	fmt.Println()
	log.Printf("received %v, shutting down", s)
}
