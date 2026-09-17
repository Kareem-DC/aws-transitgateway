# aws-transitgateway


---

# AWS Transit Gateway (TGW)

## What is a Tranist Gateway?

- A Transit Gateway (TGW) is a regional network hub that lets you connect multiple VPCs (and on-premises networks, via VPN or Direct Connect) through a single point, instead of wiring each one directly to every other one. It acts like a router sitting between all your attachments — each VPC, VPN, or Direct Connect connection attaches to the TGW once, and the TGW's route tables control who can reach whom.
The core problem it solves is VPC peering doesn't scale. Peering is point-to-point and non-transitive — connecting 5 VPCs to each other fully needs 10 peering connections, and none of them can route traffic through another peered VPC. A TGW turns that into 5 attachments total, with routing handled centrally.

## Use cases

- Hub-and-spoke VPC connectivity — many VPCs (dev, staging, prod, shared services) all needing to reach each other or a shared resource, without a full mesh of peering connections.
  
- Centralized egress/ingress — routing all VPCs' internet-bound or on-prem-bound traffic through a shared inspection VPC (firewall appliances, IDS/IPS) before it goes further.
  
- Hybrid connectivity at scale — attaching VPN or Direct Connect once at the TGW and having every attached VPC reach on-premises networks, instead of a separate VPN per VPC.

- Multi-account, multi-region architectures — TGW supports cross-account sharing via AWS RAM, and TGW peering connects hubs across regions.

- Segmented routing — using multiple TGW route tables (rather than the single default one) to enforce that, say, dev VPCs can't reach prod VPCs even though both attach to the same TGW.

## What it's not for

- Two VPCs that just need to talk to each other, permanently, with nothing else in the picture — that's what VPC peering is for, and it's simpler and cheaper (no per-GB TGW data processing charge) for that narrow case. TGW earns its cost once you're past a handful of VPCs or need transitive routing.

- Intra-VPC routing — it only connects attachments to each other; it doesn't do anything for resources within the same VPC or subnet.

- Load balancing or traffic inspection itself — the TGW routes packets, it doesn't inspect or balance them. You still need a firewall appliance, NAT gateway, or load balancer for those jobs; the TGW just gets traffic to them.

- A substitute for security groups/NACLs — it moves packets between networks it's allowed to reach; it doesn't enforce security policy beyond routing. You still need SGs/NACLs on the actual resources.

- DNS resolution across VPCs — that's a separate concern (Route 53 Resolver + associating it across VPCs), not something TGW handles on its own even though it's commonly paired with TGW setups.

- Global/interregional routing on its own — a single TGW is regional; cross-region requires explicit TGW peering between two regional TGWs, it's not automatic.
