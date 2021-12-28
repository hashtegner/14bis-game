function isCollided(ax, ay, aw, ah, bx, by, bw, bh)
  return bx < ax + aw and
        ax < bx + bw and
        ay < by + bh and
        by < ay + ah
end
